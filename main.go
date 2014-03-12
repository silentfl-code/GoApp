package main

import (
	"code.google.com/p/go.net/websocket"
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"sync"
)

var nicks = [...]string{"Sai", "Kensaku Segoe", "Utaro Hashimoto", "Minoru Kitani", "Toshihiro Shimamura", "Hidehiro Miyashita", "Dogen Handa", "Go Seigen", "Kaku Takagawa", "Hosai Fujisawa", "Eio Sakata", "Shuchi Kubouchi", "Toshio Sakai", "Masao Sugiuchi", "Takeo Kajiwara", "Sunao Sato", "Hideyuki Fujisawa", "Toshiro Yamabe"}

type user struct {
	Nickname string
	Rank     string
}

type Users struct {
	hits  int
	users map[*websocket.Conn]user
	sync.Mutex
}

func getUser(id int) user {
	return user{nicks[id%len(nicks)], strconv.Itoa((id+1)%7) + "d"}
}

func (p *Users) Add(ws *websocket.Conn) user {
	sendUserlist(ws) //отправляем новому пользователю текущий список участников
	p.Lock()
	CurrUser := getUser(p.hits)
	p.hits++
	p.users[ws] = CurrUser
	p.Unlock()

	//рассылаем всем уведомление о новом участнике
	arr := make([]user, 1)
	arr[0] = CurrUser
	data, _ := json.Marshal(arr) //TO DO: обработка ошибок
	broadcastMessage <- Message{Types: "users", Action: "add", Users: string(data)}
	return CurrUser
}

func (p *Users) Del(ws *websocket.Conn) {
	p.Lock()
	CurUser := p.users[ws]
	delete(p.users, ws)
	data, _ := json.Marshal(CurUser)
	broadcastMessage <- Message{Types: "users", Action: "del", Users: string(data)}
	p.Unlock()
}

var users Users

// = make(map[*websocket.Conn]user)

type Message struct {
	Types   string `json:"types"`
	Message string `json:"message"`
	User    string `json:"user"`
	Action  string `json:"action"`
	Users   string `json:"users"`
}

var broadcastMessage chan Message = make(chan Message, 10)

//TO DO:
//сделать броадкаст изменений в списке пользователей

func init() {
	users.users = make(map[*websocket.Conn]user)
}

func main() {
	go Broadcaster()
	//основная часть
	http.Handle("/ws", websocket.Handler(WebSocketServer))
	http.HandleFunc("/", mainHandle)
	err := http.ListenAndServe("localhost:8080", nil)
	if err != nil {
		panic("ListenAndServe: " + err.Error())
	}
}

//рассылка всем участникам сообщения
func Broadcaster() {
	for {
		select {
		//TO DO: сделать фильтрацию сообщения от всяких "хакерских" бяк
		case message := <-broadcastMessage:
			for v, _ := range users.users {
				websocket.JSON.Send(v, message)
			}
		}
	}
}

func mainHandle(w http.ResponseWriter, r *http.Request) {
	url := r.URL.Path[1:]
	//log.Println(url)
	http.ServeFile(w, r, url)
}

func WebSocketServer(ws *websocket.Conn) {
	log.Printf("ws connect: %v\n", ws.RemoteAddr())
	var msg Message
	var in []byte
	CurrUser := users.Add(ws)
	defer users.Del(ws)
	defer func() { ws.Close(); log.Printf("ws disconnect: %v\n", ws.RemoteAddr()) }()

	for {
		err := websocket.Message.Receive(ws, &in)
		if err != nil { //пользователь ушел
			return
		}
		err = json.Unmarshal(in, &msg) //TO DO: обработка ошибок
		if err != nil {
			log.Println("json err:", err)
			return
		}
		log.Printf("%+v", msg)
		switch msg.Types {
		case "message":
			msg.User = CurrUser.Nickname
			broadcastMessage <- msg
		case "users":
			if msg.Action == "list" { //остальные типы action игнорятся
				go sendUserlist(ws)
			}
		}
	}
}

//отправка актуального списка пользователей онлайн
func sendUserlist(ws *websocket.Conn) {
	users.Lock()
	userlist := make([]user, len(users.users))
	i := 0
	for _, v := range users.users {
		userlist[i] = v
		i++
	}
	users.Unlock()
	data, _ := json.Marshal(userlist) //TO DO: сделать обработку ошибок
	websocket.JSON.Send(ws, Message{Types: "users", Action: "add", Users: string(data)})
}

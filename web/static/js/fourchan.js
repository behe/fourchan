let Fourchan = {
  init(socket) {
    socket.connect()
    this.onReady(socket)
  },
  onReady(socket) {
    let messageChannel = socket.channel("messages:updates")

    messageChannel.on("ping", ({count}) => {
      // let msgContainer = document.getElementById("updates")
      // msgContainer.innerHTML = `<h2>PING ${count}</h2>`
      console.log(`PING ${count}`)
    })

    messageChannel.on("tweet", ({text}) => {
      let msgContainer = document.getElementById("updates")
      msgContainer.innerHTML = `<h2>${text}</h2>`
    })

    messageChannel.join()
      .receive("ok", resp => {
        console.log("joined the message channel", resp)
        messageChannel.push("subscribe", {topic: "bieber"})
          .receive("error", e => console.log("subscription error", e))
      })
      .receive("error", reason => console.log("join failed", reason))
  }
}
export default Fourchan

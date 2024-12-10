import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="toggles"
export default class extends Controller {
    toggle() {
        this.element.parentNode.classList.toggle("active")
    }

    async aiMakeMessage() {
      let receive = false

      const layerContent = document.getElementById("layerContent");
      layerContent.innerText = "加载中。。。"
      document.getElementById("layer").style.display = "flex"
      const eventSource = new EventSource("/word/makeMessageByAI");
      eventSource.onmessage = (event) => {
        if (!receive) layerContent.innerText = ''
        receive = true
        const response = JSON.parse(event.data)
        layerContent.innerText += response['content'];
      };

      eventSource.onerror = function(event) {
        eventSource.close();
      };
    }

    closeLayer() {
        const closeLayBtn = document.getElementById("closeLayer");
        document.getElementById("layer").style.display = "none"
    }
}

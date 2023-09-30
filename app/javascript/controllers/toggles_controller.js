import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="toggles"
export default class extends Controller {
    toggle() {
        this.element.parentNode.classList.toggle("active")
    }

    async aiMakeMessage() {
        const layerContent = document.getElementById("layerContent");
        layerContent.innerText = "加载中。。。"
        document.getElementById("layer").style.display = "flex"
        const response = await fetch("/word/makeMessageByAI", {method: "GET",});
        layerContent.innerText = await response.text()
    }

    closeLayer() {
        const closeLayBtn = document.getElementById("closeLayer");
        document.getElementById("layer").style.display = "none"
    }
}

import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="toggles"
export default class extends Controller {
    toggle() {
        this.element.parentNode.classList.toggle("active")
    }

    async aiMakeMessage() {
        const response = await fetch("/word/makeMessageByAI", {method: "GET",});
        const aiMessage = await response.text();
        const layerContent = document.getElementById("layerContent");
        layerContent.innerText = aiMessage
        document.getElementById("layer").style.display = "flex"
    }

    closeLayer() {
        const closeLayBtn = document.getElementById("closeLayer");
        document.getElementById("layer").style.display = "none"
    }
}

import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="toggles"
export default class extends Controller {
    connect() {
        const openLayerBtn = document.getElementById("openLayer");
        openLayerBtn.addEventListener("click", () => {
            document.getElementById("layer").style.display = "flex"
        })

        const closeLayBtn = document.getElementById("closeLayer");
        closeLayBtn.addEventListener("click",() => {
            document.getElementById("layer").style.display = "none"
        })
    }

    toggle() {
        this.element.parentNode.classList.toggle("active")
    }
}

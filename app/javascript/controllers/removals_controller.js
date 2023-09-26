import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {
    remove() {
        this.element.remove()
    }

    inertTmpNode() {
        const targetWord = this.element.parentNode.parentNode.parentNode
        const words = targetWord.parentNode
        const tmpWord = document.createElement("div")
        const height = this.element.parentNode.parentElement.scrollHeight
        tmpWord.style["height"] = height + "px"
        tmpWord.id = "tmp_word"
        tmpWord.setAttribute("data-controller", "removals");
        tmpWord.setAttribute("data-action", "transitionend->removals#removeTmpNode");
        words.insertBefore(tmpWord, targetWord)
    }

    removeTmpNode() {
        this.element.remove();
    }
}

import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="word"
export default class extends Controller {
    connect() {
    }

    sound() {
        const soundLink = this.element.firstElementChild;
        soundLink.pause()
        soundLink.currentTime = 0;
        soundLink.play()
    }
}

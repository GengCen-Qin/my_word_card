import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {
    connect() {
    }

    // 删除flashMessage
    remove() {
        this.element.remove()
    }
}

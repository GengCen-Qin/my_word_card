import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {
    connect() {
        this.load = 0
    }

    blurring(target) {
        console.log("blur")
        this.load++
        if (this.load > 10) {
            clearInterval(this.int)
        }
        target.style.opacity = this.scale(this.load, 0, 10, 1, 0)
    }

    fade(event) {
        event.preventDefault()
        const targetElement = this.element.parentNode.parentElement
        this.int = setInterval(() => {
            this.blurring(targetElement)
        }, 30)
        targetElement.style.height = getComputedStyle(targetElement).height
        targetElement.style.margin = 0;
        targetElement.style.padding = 0;

        targetElement.addEventListener("transitionend", async () => {
            let form = this.element.parentElement;
            const formData = new FormData(form);
            try {
                const response = await fetch(form.getAttribute("action"), {
                    method: form.getAttribute("method"),
                    body: formData
                });

                // 将响应转换为Turbo Stream对象
                const turboStream = await response.text();

                // 处理Turbo Stream响应
                Turbo.renderStreamMessage(turboStream);
            } catch (error) {
                console.log("表单提交失败:", error);
            }
        })

        setTimeout(() => {
            targetElement.style["height"] = 0;
        }, 0);
    }

    remove() {
        this.element.remove()
    }

    // https://stackoverflow.com/questions/10756313/javascript-jquery-map-a-range-of-numbers-to-another-range-of-numbers
    scale = (num, in_min, in_max, out_min, out_max) => {
        return ((num - in_min) * (out_max - out_min)) / (in_max - in_min) + out_min
    }
}

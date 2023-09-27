import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {
    remove() {
        this.element.remove()
    }

    fade(event) {
        event.preventDefault()
        const targetElement = this.element.parentNode.parentElement
        targetElement.style.height = getComputedStyle(targetElement).height
        targetElement.style.visibility = "hidden";
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
}

import {Controller} from "@hotwired/stimulus"
import { marked } from 'marked'

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
        if (!receive) {
          layerContent.innerText = ''; // 清空内容
          layerContent.innerHTML = ''; // 清空 HTML 内容
        }
        receive = true;
        const response = JSON.parse(event.data);
        const markdownContent = response['content'];
        const htmlContent = marked(markdownContent); // 将 Markdown 转换为 HTML
        layerContent.innerHTML = htmlContent; // 将 HTML 内容插入到页面中
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

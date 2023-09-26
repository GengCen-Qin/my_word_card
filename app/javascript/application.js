// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

window.addEventListener('scroll', checkBoxes)

checkBoxes()

function checkBoxes() {
    const boxes = document.querySelectorAll(".word")
    const triggerBottom = window.innerHeight / 6 * 5
    boxes.forEach(box => {
        const boxTop = box.getBoundingClientRect().top

        if (boxTop < triggerBottom) {
            box.classList.add('show')
        } else {
            box.classList.remove('show')
        }
    })
}

function resetInput() {
    const input = document.getElementById("search")
    input.value = ""
}

function removeTmpWordAnimation() {
    const tmpWord = document.getElementById("tmp_word")
    if (tmpWord) tmpWord.classList.add("word__tmp__remove")
}

document.addEventListener('turbo:before-stream-render', function (event) {
    removeTmpWordAnimation()
    event.preventDefault();
    event.detail.newStream.performAction();
    checkBoxes()
    resetInput()
})
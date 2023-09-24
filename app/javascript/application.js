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

document.addEventListener('turbo:before-stream-render', function(event) {
    event.preventDefault();
    event.detail.newStream.performAction();
    checkBoxes()
})
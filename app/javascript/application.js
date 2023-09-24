// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

const boxes = document.querySelectorAll(".word")

window.addEventListener('scroll', checkBoxes)

checkBoxes()

function checkBoxes() {
    const triggerBottom = window.innerHeight / 6 * 5

    boxes.forEach(box => {
        const boxTop = box.getBoundingClientRect().top

        if(boxTop < triggerBottom) {
            box.classList.add('show')
        } else {
            box.classList.remove('show')
        }
    })
}
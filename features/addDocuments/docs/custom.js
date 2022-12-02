document.addEventListener("click", ({ target }) => {
  if (target.classList.contains("editable")) {
    const willEditing = !target.classList.contains("editing");
    target.contentEditable = willEditing;
    target.classList.toggle("editing", willEditing);
    target.children[0].style.resize = willEditing ? "vertical" : null;
    if (willEditing) {
      target.spellcheck = false;
    }
  }
});

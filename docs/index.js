const $$ = document.getElementById.bind(document);

function translate() {
  function isLanguage(language) {
    return $$('choose_lang_' + language).checked;
  }
  if (isLanguage('en')) {
  }
  if (isLanguage('cn')) {
  }
}
translate();

for (let choice of document.getElementsByName('lang')) {
  choice.addEventListener('click', () => {
    translate();
  });
}

document.addEventListener('DOMContentLoaded', function () {
  if (window.location.hostname == 'localhost') {
    //set local instance to green
    document.getElementById('headernav-container').parentElement.style.backgroundColor =
      '#008000';
  }
  if (window.location.hostname == 'archives-test.libraries.emory.edu') {
    //set dev to yellow
    document.getElementById('headernav-container').parentElement.style.backgroundColor =
      '#ffffabf2';
  }
});

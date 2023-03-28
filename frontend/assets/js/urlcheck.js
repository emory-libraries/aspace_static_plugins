document.addEventListener('DOMContentLoaded', function () {
  if (window.location.hostname == 'localhost') {
    //set local instance to green
    document.getElementById('headernav-container').style.backgroundColor =
      '#0080006b';
  }
  if (window.location.hostname == 'archives-test.libraries.emory.edu') {
    //set dev to yellow
    document.getElementById('headernav-container').style.backgroundColor =
      '#ffff006b';
  }
});

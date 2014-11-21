(function() {

var opts = {
  lines: 15, // The number of lines to draw
  length: 0, // The length of each line
  width: 3, // The line thickness
  radius: 29, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#000', // #rgb or #rrggbb or array of colors
  speed: 1, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  top: '50%', // Top position relative to parent
  left: '50%' // Left position relative to parent
};

var spinner = new Spinner(opts).spin();  

var restaurants = {
  vendelas: {url: '/vendelas',  name: 'Vendelas'},
  meatbar:  {url: '/meatbar',   name: 'Köttbaren'},
  fei:      {url: '/fei',       name: 'FEI'},
  grill:    {url: '/grill',     name: 'Grill'}
};

var menu_template;
var weekday = new Date().getDay();

$(document).ready(function() {
  var source   = $("#menu-template").html();
  menu_template = Handlebars.compile(source);


  $('#spinner_wrapper').append($(spinner.el));

  getFei().then(stopSpinner);
  getGrill().then(stopSpinner);
  getMeatbar().then(stopSpinner);
  getVendelas().then(stopSpinner);

});

function stopSpinner() {
  $('#spinner_wrapper').hide();
}

function getMenu(key) {
  return $.get(restaurants[key].url).then(function(data) {
    renderMenu(restaurants[key].name, data);
  });
}

function renderMenu(name, menus) {
  var html = menu_template({name: name, menu: menus[weekday - 1]});
  $('#menus').append(html);
}

function getVendelas() {
  return getMenu('vendelas');
}

function getMeatbar() {
  return getMenu('meatbar');
}

function getFei() {
  return getMenu('fei');
}

function getGrill() {
  return getMenu('grill');
}

})();
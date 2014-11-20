(function() {

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

  getVendelas().then(getMeatbar).then(getFei).then(getGrill);

});

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
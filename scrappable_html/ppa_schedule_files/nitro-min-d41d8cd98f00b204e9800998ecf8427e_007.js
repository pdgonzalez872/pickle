var geocoder;var test=3;function getGeocoder(){return geocoder}function initialize(a,e,o,t,l,s,r,n){var g;if(r===undefined){if(typeof gmapstyles!=="undefined"&&gmapstyles!="default"){r=JSON.parse(gmapstyles)}}geocoder=new google.maps.Geocoder;var i=0;if(s==false){var d={mapTypeId:o,zoom:t,scrollwheel:false,styles:r,zoomControl:true,draggable:false}}else{var d={mapTypeId:o,zoom:t,styles:r,zoomControl:true,scrollwheel:true}}var m=document.getElementById(a);g=new google.maps.Map(m,d);if(l=="latlng"){var p=e.split(",",2);var c=parseFloat(p[0]);var f=parseFloat(p[1]);var i=new google.maps.LatLng(c,f);geocoder.geocode({latLng:i},function(e,o){if(o==google.maps.GeocoderStatus.OK){var t=new google.maps.Marker({map:g,position:i,icon:n});g.setCenter(t.getPosition())}else{document.getElementById(a).style.display="none"}})}else if(e==""){}else{geocoder.geocode({address:e},function(e,o){if(o==google.maps.GeocoderStatus.OK){g.setCenter(e[0].geometry.location);var t=new google.maps.Marker({map:g,position:e[0].geometry.location,icon:n})}else{document.getElementById(a).style.display="none"}})}}
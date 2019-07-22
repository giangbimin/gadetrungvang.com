	
	// WPForms AJAX Submission JS
	
	// this variable will record that a form was submitted through ajax
	// or that the form was submitted at all
	
	jQuery(document).ready(function($) {
    var submit = $("#wpforms-submit-9");
    submit.click(function(){
        $('.loading').show();
        var form = submit.closest("form");
        data = form.serialize();
        
        $.ajax({
            type : 'GET', 
            url : 'https://script.google.com/macros/s/AKfycbzOXhF63KgjnSLaW-DjbKCxB-To_w3ebAJ3Bt5u97U8cSzYqkk/exec',
            dataType:'json',
            crossDomain : true,
            data : data,
            success : function(data) {
              if(data == 'false') 
              {
                 alert('đăng kí không thành công xin vui lòng thử ');
              }else{
                 alert('Đã đăng kí thành công');
              }
            }
        });
        $('.loading').hide();
        return false;
    });

   var submit = $("#wpforms-submit-9-popup");
    submit.click(function(){
        $('.loading').show();
        var form = submit.closest("form");
        data = form.serialize();
        
        $.ajax({
            type : 'GET', 
            url : 'https://script.google.com/macros/s/AKfycbzOXhF63KgjnSLaW-DjbKCxB-To_w3ebAJ3Bt5u97U8cSzYqkk/exec',
            dataType:'json',
            crossDomain : true,
            data : data,
            success : function(data) {
              if(data == 'false') 
              {
                 alert('đăng kí không thành công xin vui lòng thử ');
              }else{
                 alert('Đã đăng kí thành công');
              }
            }
        });
        $('#mask').hide();
        $('.window').hide();
        $('.loading').hide();
        return false;
    });
	});

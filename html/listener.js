/* Need Help? Join my discord @ discord.gg/yWddFpQ */ 
$(function()
{
    window.addEventListener('message', function(event)
    {   
        var data = event.data;
        if (data.action == 'open' || data.action == 'close') {
            var wrap = $('#wrap');
            if (data.action == 'open') 
            {
            /*wrap.find('table').append("<tr style='text-allign: center;' class=\"heading\"><th>ID</th><th>Name</th><th>Ping</th><th>Activity</th></tr>");*/
            wrap.find('table').append("<tr style='text-allign: center;' class=\"heading\"><th>ID</th><th>Ping</th><th>Stav</th></tr>");
            } 
            else if (data.action == 'close')
            {
                document.getElementById("ptbl").innerHTML = "";
                $('#wrap').hide();
                return;
            }
            wrap.find('table').append(data.text);
            $('#wrap').show();
        }
    }, false);
});

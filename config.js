/* Config 2 */
var headerImage = 'https://media.discordapp.net/attachments/944368131806220320/1036362320433139822/unknown.png'; /*https://i.imgur.com/SqJCooD.png*/
var footer = 'Footer Note  or URL';
/* ------------------------------- */
/* ext no touchy touchy */
document.getElementById('footer').innerHTML = footer;
document.getElementById('headerImage').src = headerImage;
/* Need Help? Join my discord @ discord.gg/yWddFpQ */

$(function()
{
    window.addEventListener('message', function(event)
    {   
        var data = event.data;
        if (data.action == 'update') {
            headerImage = data.header;
            footer = data.footer;
            document.getElementById('footer').innerHTML = footer;
            document.getElementById('headerImage').src = headerImage;
            console.log('Testz')
        }
    }, false);
});

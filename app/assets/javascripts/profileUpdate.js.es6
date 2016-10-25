$(document).on("turbolinks:load", () => {
    $("#edit_user_form").on("ajax:success", function (e, data) {
        $("#user_username").text(data.data.username);
        $("#header_user_link").text(data.data.username);
        $("#user_email").text(data.data.email);
    });
});
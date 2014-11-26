# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(".issues_area").each ->
  target_area = $(this)
  repo_name = $(this).data("repo")
  $.ajax "/get_issues/#{repo_name}",
    async: true
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
    success: (data, textStatus, jqXHR) ->
      if !data || Object.keys(data).length == 0
        target_area.html('')
        return

      inshtml = '<div class="panel panel-default"><table class="table table-bordered">'
      for i,value of data
        inshtml += "<tr>"
        inshtml += "<td>"
        inshtml += "<h4 class=\"issue-title\"><a href=\"#{value.html_url}\" target=\"_blank\"><u>#{value.title}</u></a></h4>"
        if value.labels
          for j,label of value.labels
            inshtml += '<span class="issue-label" style="background-color:#' + label.color + '">' + label.name + '</span>'
        inshtml += "<p>##{value.number} opened #{value.created_at_format} by #{value.user.login} </p>"
        inshtml += '<div style="float: left; margin-right: 1em;">'
        inshtml += "<img src=\"#{value.user.avatar_url}\" class=\"img-responsive\" alt=\"#{value.user.login}\" height=\"48\" width=\"48\">"
        inshtml += "</div>"
        inshtml += "<p>" + urlAutoLink(value.body) + "</p>"
        inshtml += "<span class=\"glyphicon glyphicon-comment\"></span> #{value.comments}"
        inshtml += '</td>'
        inshtml += '</tr>'
      inshtml += '</table></div>'
      target_area.html(inshtml)
      $('#side_repo_name_' + repo_name + ' a').append('(' + Object.keys(data).length + ')').css("color","red")

urlAutoLink = (str) -> str.replace(/\r?\n/g, '<br>').replace(/(https?:\/\/[\w\-\.!~\*\';\/\?:&@=\+\$,%#\[\]]+)/gi, "<a href='$1' target='_blank'>$1</a>")

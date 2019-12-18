# Repositories
{:.no_toc}

## GitHub

{% assign tuples = site.data.github | get %}

{% for tuple in tuples %}

{% assign user = tuple[0] %}
{% assign repos = tuple[1] %}

### {% if user.name %}{{ user.name }}{% else %}{{ user.login }}{% endif %}

{% for repo in repos %}

#### {{ repo.full_name }}

{{ repo.description }}
 
[{{ repo.html_url }}]({{ repo.html_url }})

{% endfor %}

{% endfor %}

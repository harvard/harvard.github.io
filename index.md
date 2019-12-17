# Repositories

## GitHub

{% for row in site.data.github %}
{% assign repo = row.repo | get %}

{% if repo %}

### {{ repo.full_name }}

{{ repo.description }}

[{{ repo.html_url }}]({{ repo.html_url }})

{% endif %}

{% endfor %}

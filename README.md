# Open Source at Harvard

## Contributing

Open a pull request, adding your repo's URL to [_data/github.tsv](blob/develop/_data/github.tsv).

## Developing

```
bundle install
bundle exec jekyll build
open _site/index.html
```

## Notes

In [index.md](blob/develop/index.md), `get` is a Jekyll filter implemented in [_plugins/get.rb](blob/develop/_plugins/get.rb) that takes [_data/github.tsv](blob/develop/_data/github.tsv) as input and returns an array of `[user, repos]` "tuples" (i.e., arrays), wherein `user` (the owner of `repos`) is a hash like <https://api.github.com/users/harvard>, and `repos` is a hash like <https://api.github.com/repos/harvard/harvard.github.io>.

You can iterate over those tuples as follows:

```

{% assign tuples = site.data.github | get %}

{% for tuple in tuples %}

{% assign user = tuple[0] %}
{% assign repos = tuple[1] %}

{% for repo in repos %}

...

{% endfor %}

{% endfor %}
```

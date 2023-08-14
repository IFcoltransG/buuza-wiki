---
layout: page
title: Site Map
permalink: /sitemap
---

# {{ page.title }}

Here is a list of pages on this site.

{% for page in site.wiki %}
  - [{{page.title}}]({{ site.baseurl }}{{ page.url }})
{% endfor %}

<script>
  function checkHash() {
    if (window.location.hash == "#random") {
      let links = document.getElementsByTagName("a");
      let chosenLink = links[Math.floor(Math.random()*links.length)];
      chosenLink.click();
    }
  }

  window.addEventListener('hashchange', checkHash);
  window.addEventListener('load', checkHash);
  window.addEventListener('click', checkHash);
</script>

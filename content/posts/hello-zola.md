+++
title = "Hello, Zola!"
date = 2019-04-11
aliases = ["/posts/hello-gutenberg"]

[taxonomies]
tags = ["rust", "website"]

[extra]
+++

For the past couple of years I've used [Hugo](https://gohugo.io/) for my
personal website [cgmcintyre.com](http://cgmcintyre.com).

I picked Hugo for its popularity, and got up and running super quick with
the [minimo](https://themes.gohugo.io/minimo/) theme. However I haven't
really done much with the site since I put it up...

I think part of the reason for this is that using someone elses theme made
the process of generating the site a bit too magic. I looked into
designing a Hugo theme, but I'm not used to go templating and found that
Hugo was maybe a bit too powerful for my simple use case.

So, I've moved my site to [Zola](https://www.getzola.org), a simple static
site generator written in Rust. I've designed the theme for my website
from scratch, which has helped me feel comfortable. My `config.toml` file
feels light, and I'm happy with how Zola works under the hood :)

Here's to a more active site!

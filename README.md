# Doex

An elixir implementation of the [Digital Ocean API v2](https://developers.digitalocean.com/documentation/v2/).

From their documentation:

    The DigitalOcean API allows you to manage Droplets and resources within
    the DigitalOcean cloud in a simple, programmatic way using conventional
    HTTP requests. The endpoints are intuitive and powerful, allowing you to
    easily make calls to retrieve information or to execute actions.

    All of the functionality that you are familiar with in the DigitalOcean
    control panel is also available through the API, allowing you to script
    the complex actions that your situation requires.

    The API documentation will start with a general overview about the design
    and technology that has been implemented, followed by reference information
    about specific endpoints.

This Elixir API gives you both in code access to the API as well as a set of helper mix tasks to allow you to automate your infrastructure through the shell.

## Installation

### Global Tasks

To install the mix tasks globally on your environment, you can several mechanism

```bash
# Install from GitHub
mix archive.install github capbash/doex

# Install form HEX.pm
mix archive.install hex doex
```

To install a specific version, branch, tag or commit, adjust any one of the following

```bash
# Install from a specific version
mix archive.install hex doex 1.2.3

# Install from the latest of a specific branch
mix archive.install github capbash/doex branch git_branch

# Install from a specific tag
mix archive.install github capbash/doex tag git_tag

# Install from a specific commit
mix archive.install github capbash/doex ref git_ref
```

Checkout [mix archive.install](https://hexdocs.pm/mix/Mix.Tasks.Archive.Install.html) for
more information about installing global tasks.

### Project Dependency

In you are building on top of Digital Ocean API within Elixir, then
you can add the project as a dependency.

```elixir
@deps [
  doex: "~> 0.3.0"
]
```

## License

MIT License

----
Created:  2017-07-24Z

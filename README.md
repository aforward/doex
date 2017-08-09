# Doex

An elixir implementation of the [DigitalOcean API v2](https://developers.digitalocean.com/documentation/v2/).

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

This Elixir DigitalOcean (DO) API gives you access to the API through three means:

* A command line escript tool called `doex`
* A set of mix tasks `doex *`, or
* Directly from Elixir code using `Doex` module

Each one of the mechanism above allow you to automate your infrastructure needs,
it more comes down to preference and environment.

## Installation

### Command Line (Latest Version)

To install the `doex` command line tool (whose only dependency is Erlang), then
you can [install it using escript](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Install.html).


```bash
# Install from GitHub
mix escript.install github capbash/doex

# Install form HEX.pm
mix escript.install hex doex
```

If you see a warning like

```bash
warning: you must append "~/.mix/escripts" to your PATH
if you want to invoke escripts by name
```

Then, make sure to update your PATH variable.  Here's how on a Mac OS X, but each
[environment is slightly different](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path).

```bash
vi ~/.bash_profile

# Add a line like the following
PATH="$HOME/.mix/escripts:$PATH"
export PATH
```

Start a new terminal session. You will know it's working when you can *find* it using *where*

```
where doex
```

### Command Line (Other Versions)

To install a specific version, branch, tag or commit, adjust any one of the following

```bash
# Install from a specific version
mix escript.install hex doex 1.2.3

# Install from the latest of a specific branch
mix escript.install github capbash/doex branch git_branch

# Install from a specific tag
mix escript.install github capbash/doex tag git_tag

# Install from a specific commit
mix escript.install github capbash/doex ref git_ref
```

Again, checkout [mix escript.install](https://hexdocs.pm/mix/Mix.Tasks.Escript.Install.html) for
more information about installing global tasks.

### Mix Tasks

If you have an Elixir project that you want to interact with the
DigitalOcean API, then you install the app by adding a dependency
to your `mix.exs` file.

```elixir
@deps [
  doex: "~> 0.5.2"
]
```

This will give you access to `doex *` tasks (instead of globally installing
the `doex` escript). You will also have programtic access from your `Doex` module
as well; so you could expose feature directly within your application as well.

## Configure DO Token

Before you can use the DO API, you will need to configure access to your DigitalOcean
account.  For this, you will need your [API TOKEN](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#how-to-generate-a-personal-access-token)

Let's say your token is ABC123, then configure it as follows:

    # using escript
    doex init
    doex config token ABC123

    # using mix tasks
    doex init
    doex config token ABC123

And to confirm it's set, run

    doex config

And the output should look similar to:

    ssh_keys: []
    token: "ABC123"
    url: "https://api.digitalocean.com/v2"

Notice the empty `ssh_keys`.  Please look at [DO documentation on SSH Keys](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets)
and configure them right away.  With the SSH Keys set, you will have secure
and passwordless access to your new droplet, enabling more convient scripting.  To
retrieve your SSH Key IDs, run the following command

    # using escript
    doex get /account/keys

    # using mix tasks
    doex get /account/keys

The output will be similar to the following, and it's the IDs you want.

    {:ok,
     %{"links" => %{}, "meta" => %{"total" => 2},
       "ssh_keys" => [%{"fingerprint" => "18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33",
          "id" => 555213, "name" => "mbp",
          "public_key" => "ssh-dss ABC123"},
        %{"fingerprint" => "19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34",
          "id" => 555214, "name" => "andrew13mbp",
          "public_key" => "ssh-rsa DEF456"}]}}

From the example above (please adjust for your output), the IDs are `555213`, and `555214`.
These can be set by running

    doex config ssh_keys 555213 555214

Now, every droplet you create will, by default (and can be overwritten), be accessible
by all computers that have those public/private keys.

## Available Commands / Tasks

To get help on the available commands, run

    # using escript
    doex

    # using mix tasks
    mix doex

The output will look similar to the following

    doex v0.3.0
    doex is a API client for Digital Ocean's API v2.

    Available tasks:

    doex block            # Block the command line until a condition is met
    doex config           # Reads, updates or deletes Doex config
    doex delete           # Execute a Digital Ocean API DELETE request
    doex droplets.create  # Create a droplet on Digital Ocean
    doex droplets.id      # Locate a droplet ID, by name or tag (--tag)
    doex droplets.tag     # Tag a droplet.
    doex get              # Execute a Digital Ocean API GET request
    doex id               # Locate a ID of a resource, by name or tag (--tag)
    doex init             # Initialize your doex config
    doex ip               # Get the IP of a droplet
    doex ls               # List your resources.
    doex post             # Execute a Digital Ocean API POST request
    doex put              # Execute a Digital Ocean API PUT request
    doex scp              # Secure copy a file from <src> to your droplet's <target>
    doex snapshots.create # Creates a snapshot of an existing Digital Ocean droplet
    doex ssh              # Execute a command on your droplet
    doex ssh.hostkey      # Add the droplet hostkey to the executing server

    Further information can be found here:
      -- https://hex.pm/packages/doex
      -- https://github.com/capbash/doex

Please note that the mix tasks and doex scripts provide identical functionality,
they are just structured slightly differently.

In general,

* `doex <sub command> <options> <args>` for mix tasks
* `doex <sub command> <options> <args>` for escript

Make sure that have installed doex correctly for mix tasks (if you want to use mix
tasks), or escript (if you want to use escript).

## Elixir API

These features are also available from within Elixir through `Doex` modules,
this gives you better programatic access to return data (presented as a map),
but in most cases probably is not required to automate your infrastructure.

If we start an iEX session in your project that includes the doex dependency,
you can access the same information in Elixir.

    iex> Doex.config
    %{ssh_keys: [], token: "ABC123", url: "https://api.digitalocean.com/v2"}

The underlying API calls are made through

    iex> h Doex.Api

The `source` is the DO API endpoint *after* the `url` provided above, so to
access your account information, you would run

    iex> Doex.Api.get("/account")

OR, you can go through the more generic `call`, providing the arguments in a map.

    iex> Doex.Api.call(:get, %{source: "/account"})

If your configurations are messed up (or other errors occur), it will look
similar to

    {:error,
     "Expected a 200, received 401",
     %{"id" => "unauthorized", "message" => "Unable to authenticate you."}}

If things are working as expected, a success message looks like

    {:ok,
     %{"account" => %{"droplet_limit" => 99, "email" => "me@example.com",
         "email_verified" => true, "floating_ip_limit" => 5, "status" => "active",
         "status_message" => "",
         "uuid" => "abcdefghabcdefghabcdefghabcdefghabcdefgh"}}}

To send a POST command, for example creating a new droplet, you can run

    iex> Doex.Api.post(
           "/droplets",
           %{name: "dplet001",
             region: "tor1",
             size: "512mb",
             image: "ubuntu-16-04-x64",
             ssh_keys: [12345],
             backups: false,
             ipv6: true,
             user_data: nil,
             private_networking: nil,
             volumes: nil,
             tags: ["dplet001"]})

OR, you can go through the more generic `call`

    iex> Doex.Api.call(
           :post,
           %{source: "/droplets",
             body: %{name: "dplet001",
                     region: "tor1",
                     size: "512mb",
                     image: "ubuntu-16-04-x64",
                     ssh_keys: [12345],
                     backups: false,
                     ipv6: true,
                     user_data: nil,
                     private_networking: nil,
                     volumes: nil,
                     tags: ["dplet001"]}})

The underlying configs are stored in `Doex.Worker` ([OTP GenServer](https://elixir-lang.org/getting-started/mix-otp/genserver.html)).
If you change your configurations and need them reloaded, then call
and can be reloaded using

    iex> Doex.reload

At present, there are no client specific convenience methods, but when there are
they will be located in

    iex> h Doex.Client

## License

MIT License


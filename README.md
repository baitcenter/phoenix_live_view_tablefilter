# Demo with a Table Filter

* Explanations on https://medium.com/@imartinat/table-filter-with-phoenix-liveview-cb30508e9fc0

- [X] Select Columns to be visible on the table (Part 1)
- [X] Filter Columns with dropdown list (Part 2)
- [X] Search Columns with >,>=,<,<=  for numbers and query for strings (Part 3 in the next days)
- [ ] Sort by column


To start your Phoenix server:

  * Add {:filtrex, "~> 0.4.3"} in your mix.exs file in the deps
    * More information on Filtrex [here](https://github.com/rcdilorenzo/filtrex)
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install && cd ..`
  * Import Data (test data in a CSV file in the data folder) or use the data from your tables
  * Start Phoenix endpoint with `mix phx.server`
  

To use your data from your tables:

  * Add in your context file containing the following functions from lib/demo/companies/companies.ex:
    * filter_config
    * filter_yourtable (equivalent of filter_customers)
  * Update the functions in lib/demo_web/live/filtrex.ex:
    * get_filter_list, get_search_list, get_cols
    * get_rows, get_filter_rows


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

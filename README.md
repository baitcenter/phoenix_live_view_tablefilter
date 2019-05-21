# Demo with a Table Filter

* Explanations on https://medium.com/@imartinat/table-filter-with-phoenix-liveview-cb30508e9fc0

- [X] Select Columns to be visible on the table (Part 1)
- [X] Filter Columns with dropdown list (Part 2 in the next days)
- [X] Search Columns with >,>=,<,<=  for numbers and query for strings
- [ ] Sort by column


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install && cd ..`
  * Import Data (test data in a CSV file in the data folder) or use the data from your tables
  * Start Phoenix endpoint with `mix phx.server`
  

To use the data from your tables:

  * Add in your context file containing the query functions the following functions from lib/demo/companies/companies.ex:
    * base_query : to be updated with your own base query
    * query_table and compose_query : code from https://elixirschool.com/blog/ecto-query-composition/
  * Update the functions in lib/demo_web/live/search_filter.ex:
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

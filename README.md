# OnlineBanking
This banking applicaiton allows user to deposit and withdraw money online. User can view all created transactions which includes deposits and withdrawal of money


### Create user:
User creation process will be made by admin(which needs to be developed). So for this current project we can create user by below call

iex> OnlineBanking.create_user("nitesh mishra", "nitesh", "password")
```
{:ok,
  %OnlineBanking.Helpers.User{
    account_number: 40106,
    balance: 0.0,
    full_name: "Nitesh mishra",
    password: "password",
    transactions: [],
    user_name: "nitesh"
}}
```


### User login page

<img width="1287" alt="Screenshot 2021-12-06 at 9 26 45 PM" src="https://user-images.githubusercontent.com/20892499/144880398-98cbceaa-caeb-43f7-990e-819420a23a57.png">

### User landing page after login

<img width="1263" alt="Screenshot 2021-12-06 at 7 29 25 PM" src="https://user-images.githubusercontent.com/20892499/144880464-2596b7a9-651b-4e87-8133-767c418d9627.png">

### TODOs
  1. Once user will perform deposit money action there should be manual approval based on bank has taken money
  2. Proper admin pannel for user/ account sign up
  3. UI is not in great condition ;) we need to create based on design

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`


<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>CSC561 | Lab1c</title>
  </head>
<body>

<!-- <h3>Status of all of our inventory items - (Inventory -> { belongsTo } -> Status)</h3>

<table border="1">
				<thead>
                    <th>Inventory Item</th>
					          <th>Description</th>
				</thead>

				<tbody>
					@foreach ($inventories as $inventory)
                    <tr>
                            <td>{{ $inventory->description }}</td>
							              <td>{{ $inventory->status->description }}</td>
                    </tr>
                     @endforeach

                </tbody>
</table> 

<h3>Inventory Items that have a status of Checked Out - (Status -> { hasMany } -> Inventory)</h3>

<table border="1">
				<thead>
                    <th>Inventory Item</th>
					          <th>Description</th>
				</thead>

				<tbody>
					@foreach ($statuses->where('description', 'Checked out')->first()->inventory as $checked_out_inventory)
                    <tr>
                            <td>{{ $checked_out_inventory->description }}</td>
							              <td>{{ $checked_out_inventory->status->description }}</td>
                    </tr>
                     @endforeach

                </tbody>
</table>  -->

<h3>Inventory items checked out by user1</h3>

<table border="1">
  <thead>
    <th>User ID</th>
    <th>Item</th>
    <th>Checkout Time</th>
  <thead>
  <tbody>
    @foreach ($transactions->where('user_id', 1) as $user1_transactions)
      <tr>
        <td>{{ $user1_transactions->user_id }}</td>
        <td>{{ $user1_transactions->inventory->description }}</td>
        <td>{{ $user1_transactions->checkout_time }}</td>
      </tr>
    @endforeach
  </tbody> 
</table>

<h3>Items checked out by all users before September 3 2018</h3>

<table border="1">
  <thead>
    <th>User Name</th>
    <th>Item</th>
    <th>Checkout Time</th>
    <th>Status</th>
  <thead>
  <tbody>
    @foreach ($transactions->where('checkout_time', '<', '2018-09-03') as $early_transactions)
      <tr>
        <td>{{ $early_transactions->user->first_name }}</td>
        <td>{{ $early_transactions->inventory->description }}</td>
        <td>{{ $early_transactions->checkout_time }}</td>
        <td>{{ $early_transactions->inventory->status->description }}
      </tr>
    @endforeach
  </tbody> 
</table>

</body>
</html>

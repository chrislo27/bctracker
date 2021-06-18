% rebase('base', title='Home' if system is None else 'BCTracker')

<h1>Welcome to BCTracker!</h1>
<hr />

<div class="sidebar">
  <h2>Quick Search</h2>

  % if system is None:
    <script type="text/javascript">
      function busSearch() {
        let value = document.getElementById('bus_id_search').value;
        if (value.length > 0) {
          window.location = "{{ get_url(None) }}/bus/" + value;
        }
      }
    </script>
  % else:
    <script type="text/javascript">
      function busSearch() {
        let value = document.getElementById('bus_id_search').value;
        if (value.length > 0) {
          window.location = "{{ get_url(system.id) }}/bus/" + value;
        }
      }
    
      function routeSearch() {
        let value = document.getElementById('route_id_search').value;
        if (value.length > 0) {
          window.location = "{{ get_url(system.id) }}/routes/" + value;
        }
      }
    
      function stopSearch() {
        let value = document.getElementById('stop_id_search').value;
        if (value.length > 0) {
          window.location = "{{ get_url(system.id) }}/stops/" + value;
        }
      }
    </script>
  % end

  % if system is None:
    <form onsubmit="busSearch()" action="javascript:void(0)">
      <label for="bus_id_search">Fleet Number:</label>
      <br />
      <input type="text" id="bus_id_search" name="bus_id" method="post">
      <input type="submit" value="Search" class="button">
    </form>
  % else:
    % if system.supports_realtime:
      <form onsubmit="busSearch()" action="javascript:void(0)">
        <label for="bus_id_search">Fleet Number:</label>
        <br />
        <input type="text" id="bus_id_search" name="bus_id" method="post">
        <input type="submit" value="Search" class="button">
      </form>
    % end
    
    <form onsubmit="routeSearch()" action="javascript:void(0)">
      <label for="route_id_search">Route Number:</label>
      <br />
      <input type="text" id="route_id_search" name="route_id" method="post">
      <input type="submit" value="Search" class="button">
    </form>
    
    <form onsubmit="stopSearch()" action="javascript:void(0)">
      <label for="stop_id_search">Stop Number:</label>
      <br />
      <input type="text" id="stop_id_search" name="stop_id" method="post">
      <input type="submit" value="Search" class="button">
    </form>
  % end
</div>

<div class="body">
  <h2>Latest Updates</h2>

  <div class="home-update">
    <div class="home-update-header">
      <h3>New Deckers Out!</h3>
      April 1, 2021
    </div>
    <div class="home-update-content">
      <p>
        BCTracker has been updated to support the latest deckers, which have just entered service.
      </p>
      Stay safe everyone!
    </div>
  </div>
  <div class="home-update">
    <div class="home-update-header">
      <h3>New Website Look</h3>
      August 21, 2020
    </div>
    <div class="home-update-content">
      <p>
        BCTracker has a new look!
        We've been working hard to get this updated design ready, and there's a lot of new things for you to enjoy - including full mobile support, improved realtime navigation, maps, and much more.
      </p>
      <p>
        We've also moved the website to a new address at <a href="http://bctracker.ca">bctracker.ca</a>.
        The old URL will continue to be usable for a while, but if you've bookmarked any pages you'll want to make sure they're updated.
      </p>
      <p>
        Over the next few weeks we'll be making more changes to the systems that make the website work behind the scenes.
        You (hopefully) won't notice any differences, but it will allow us to add lots more new and exciting stuff in the future.
        We're always looking for ways to improve the website even more, and your feedback is always welcome.
        Send us an email anytime at <a href="mailto:james@bctracker.ca">james@bctracker.ca</a>
      </p>
      Enjoy!
    </div>
  </div>
</div>

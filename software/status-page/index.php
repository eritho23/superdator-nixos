<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>
    <?php
      date_default_timezone_set("Etc/UTC");
      echo "Superdator Status - " . date("Y-m-d H:i") . " UTC";
    ?>
  </title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="Superdator status page." />
  <link rel="icon" href="favicon.png">
  <style>
    * {
      font-family: -apple-system, BlinkMacSystemFont, avenir next, avenir, segoe ui, helvetica neue, Adwaita Sans, Cantarell, Ubuntu, roboto, noto, helvetica, arial, sans-serif;
    }

    code {
      font-family: Menlo, Consolas, Monaco, Adwaita Mono, Liberation Mono, Lucida Console, monospace;
      width: 100%;
      padding: 0.7rem;
      border-radius: 0.3rem;
      border: 0.1rem solid gray;
    }
  </style>
</head>

<body>
  <h1>Superdator Status</h1>

  <h2>
    Uptime
  </h2>

  <p>
    <?php
      $fd = fopen("/proc/uptime", "r");
      if (! $fd) {
        echo "Unable to read uptime.";
      } else {
        $contents = fread($fd, 64);
        $nums = explode(" ", $contents);
        if (sizeof($nums) != 2) {
          echo "Invalid format of /proc/uptime";
        }
        $total_seconds = floor(floatval($nums[0]));

        echo "System has been running for <b>";
        $days = intdiv($total_seconds, (60 * 60 * 24));
        echo $days . " ";
        if ($days != 1) {
          echo "days";
        } else {
          echo "day";
        }
        echo ", ";
        $total_seconds -= $days * (60 * 60 * 24);

        $hours = intdiv($total_seconds, (60 * 60));
        echo $hours. " ";
        if ($hours != 1) {
          echo "hours";
        } else {
          echo "hour";
        }
        echo " and ";
        $total_seconds -= $hours * (60 * 60);

        $minutes = intdiv($total_seconds, 60);
        echo $minutes. " ";
        if ($minutes != 1) {
          echo "minutes";
        } else {
          echo "minute";
        }
        echo "</b>.";
      }
    ?>
  </p>

  <h2>
    Load averages
  </h2>
  <p>Contents of /proc/uptime:</p>
  <code>
    <?php
    $fd = fopen("/proc/loadavg", "r");
    if (! $fd) {
      echo "Unable to read uptime.";
    } else {
      $contents = fread($fd, 64);
      echo $contents;
    }
    ?>
  </code>

</body>

</html>

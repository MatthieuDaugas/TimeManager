<template>
  <div id="app">

    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/users" style="margin-top:3%;">User</router-link> |
      <router-link to="/workingtime">WorkingTime</router-link> |
      <router-link to="/workingtimes">WorkingTimes</router-link> |
      <router-link to="/clockmanager">ClockManager</router-link> |
      <router-link to="/chartmanager">ChartManager</router-link> |
    </div>

    <!-- User commun à toutes les pages -->
    <User></User>

    <router-view/>
  </div>
</template>

<script>
import User from './components/User';

export default {
  components: {
    User
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>

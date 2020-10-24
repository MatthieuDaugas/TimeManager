<template>
  <div id="app">
<<<<<<< HEAD
    <!-- User commun à toutes les pages -->
=======

        
    <!-- User commun à toutes les pages -->
    <User></User>
    
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/workingtimes">WorkingTimes</router-link> |
      <router-link to="/clockmanager">ClockManager</router-link> |
      <router-link to="/chartmanager">ChartManager</router-link> |
    </div>

>>>>>>> da1f53ad25a23c7f7f7d99fc05c4a5f3bb41d108

    <div class="body col-12 p-0 w-100  d-flex mx-auto">
      <div class="p-0 col-2 ">
        <SideBar />
      </div>
      <div class="main-container w-100 d-flex flex-column position-relative ">
        <User />
        <div v-if="userId"
          class=" page d-flex justify-content-center  p-0  mx-auto flex-column position-relative"
        >
          <router-view />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import User from "./components/User";
import SideBar from "./components/SideBar";
import { mapState } from "vuex";

export default {
  components: {
    User,
    SideBar
  },
  computed: mapState({
    userId: state => state.userId
  })
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.body {
  height: 100vh;
}
.main-container {
  background-color: #d1e3dd;
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
.page {
  width: 80%;
  height: 100vh;
}
</style>

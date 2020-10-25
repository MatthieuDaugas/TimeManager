<template>
  <div id="app">
    <!-- User commun à toutes les pages -->

    <div class="body col-12 p-0 w-100  d-flex mx-auto">
      <div class="p-0 col-2 ">
        <SideBar />
      </div>
      <div class="main-container w-100 d-flex flex-column position-relative ">
        <User />
        <div v-if="userId"
          class=" p-0 d-flex h-100 w-100 mx-auto position-relative"
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
  overflow-x: hidden;
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
</style>

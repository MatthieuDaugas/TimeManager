<template>
  <div class="h-100">
    <div class="sidebar col-12 h-100 w-100 p-0">
      <div class="pt-5 mb-4 logo">
        <img src="../assets/logo.png" alt="homepage" class="light-logo" />
      </div>

      <ul v-if="userId" class="general navigation">
        <li class="main-nav">
          <span>Main</span>
          <ul>
            <li class="link-li">
              <router-link class="link-li-text" id="dashboard" to="/dashboard"
                ><span>Dashboard</span></router-link
              >
            </li>
          </ul>
        </li>
        <li class="main-nav">
          <span>Infos</span>
          <ul>
            <li class="link-li">
              <router-link
                class="link-li-text"
                id="working-time"
                to="/workingtimes"
                ><span>Working Times</span></router-link
              >
            </li>
            <li class="link-li">
              <router-link class="link-li-text" id="clocks" to="/clockmanager"
                ><span>Clocks Manager</span></router-link
              >
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  computed: mapState({
    userId: state => state.userId
  })
};
</script>


<style lang="scss">
.sidebar {
  z-index: 30;
  background-color: #32292f;
}

.logo {
  max-width: 100%;
  height: auto;
  & img {
    max-width: 60%;
    height: auto;
  }
}

.navigation {
  padding: 0;
  display: flex;
  flex-direction: column;
  & .main-nav {
    border-top: 1px solid #ffffff1f;
    text-align: left;
    padding-top: 20px;
    padding-left: 40px;
    font-weight: 600;
    transition: background-color 0.2s ease;
    cursor: pointer;
    color: #bacdb0;
    font-size: 20px;
    list-style: none;
    & .link-li {
      margin-top: 10px;
      margin-bottom: 20px;
      display: flex;
      list-style: none;
      & .link-li-text {
        padding: 10px 20px;
        padding-left: 50px;
        border-radius: 3px;
        width: 200px;
        background-position: left 10px top 50%;
        background-repeat: no-repeat;
        background-size: 30px;
        &#dashboard {
          background-image: url("../assets/icons/dashboard.svg");
        }
        &#working-time {
          background-image: url("../assets/icons/working-time.svg");
        }
        &#clocks {
          background-image: url("../assets/icons/clock-manager.svg");
        }
        &:hover {
          background-color: #3c3947;
          text-decoration: none;
        }
        &.router-link-active {
          box-shadow: 0px 0 10px 0 rgba(102, 106, 114, 0.2);
          background-color: #5753669a;
        }
      }
      & * {
        font-size: 15px;
        color: white;
        text-shadow: 2px 2px 3px rgba(172, 183, 213, 0.2);
      }
    }
  }
}

.sidebar-link {
  &:hover {
    color: #b3bbd6;
  }
}
</style>
<template>
  <div class="working-times">
    <h1>WorkingTimes</h1>
    <div id="date-filters">
      <div class="date-filter">
        <label for="">Start</label>
        <div class="inputs">
          <input
            type="date"
            v-model="startDate"
            @change="createFilter('start')"
          />
          <input
            type="time"
            v-model="startTime"
            @change="createFilter('start')"
          />
        </div>
      </div>
      <div class="date-filter">
        <label for="">End</label>
        <div class="inputs">
          <input type="date" v-model="endDate" @change="createFilter('end')" />
          <input type="time" v-model="endTime" @change="createFilter('end')" />
        </div>
      </div>
    </div>
    <div class="get-button">
      <b-button variant="primary" @click="reinitFilters" class="px-4"
        >Reset</b-button
      >
      <b-button variant="primary" @click="getWorkingTimes" class="px-4"
        >Search</b-button
      >
    </div>
    <div id="data-list" class="panel panel-default" v-if="data && data.length">
      <table class="table">
        <tr>
          <th scope="col">Time</th>
          <th scope="col">Start</th>
          <th scope="col">End</th>
        </tr>
        <tbody>
          <tr
            class="element-tr"
            v-for="element in data"
            v-bind:key="element.id"
            @click="getToWorkingTimePage(element)"
          >
            <td>{{ element.time }}</td>
            <td>{{ element.start }}</td>
            <td>{{ element.end }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-else class="no-data">
      No data to display
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data: function() {
    return {
      data: null,
      userId: 2,
      startDate: null,
      startTime: null,
      endDate: null,
      endTime: null,
      filters: {
        start: null,
        end: null
      }
    };
  },
  created: function() {
    this.getWorkingTimes();
  },
  methods: {
    getWorkingTimes() {
      const start = this.filters.start ? `start=${this.filters.start}` : "";
      const end = this.filters.end ? `end=${this.filters.end}` : "";
      axios
        .get(
          `http://localhost:4000/api/workingtimes/${this.userId}?${start}&${end}`
        )
        .then(res => {
          this.data = res?.data?.data.map(_ => ({
            id: _.id,
            time: this.calcTime(_),
            start: this.formatDate(_.start),
            end: this.formatDate(_.end)
          }));
        })
        .catch(err => console.log(err));
    },
    createFilter(moment) {
      if (this[`${moment}Date`] && this[`${moment}Time`]) {
        this.filters[moment] = `${this[`${moment}Date`]} ${
          this[`${moment}Time`]
        }`;
      }
    },
    reinitFilters() {
      this.startDate = null;
      this.startTime = null;
      this.endDate = null;
      this.endTime = null;
      this.filters = {
        start: null,
        end: null
      };
      this.getWorkingTimes();
    },
    calcTime(data) {
      const date1 = new Date(data.start).getTime();
      const date2 = new Date(data.end).getTime();
      const ms = date2 - date1;
      const totalMinutes = Math.floor(ms / 60000);
      let hours = Math.floor(totalMinutes / 60);
      hours = hours > 9 ? hours : "0" + hours;
      let minutes = totalMinutes % 60;
      minutes = minutes > 9 ? minutes : "0" + minutes;
      return `${hours}h${minutes}`;
    },
    formatDate(dateAndTime) {
      dateAndTime = dateAndTime.split("T");
      const date = dateAndTime[0]
        .split("-")
        .reverse()
        .join("/");
      const splitTime = dateAndTime[1].split(":");
      const time = `${splitTime[0]}:${splitTime[1]}`;
      return `${date} at ${time}`;
    },
    getToWorkingTimePage(element) {
      this.$router.push({
        name: "WorkingTime",
        params: {
          element
        }
      });
    }
  }
};
</script>

<style lang="scss">
.working-times {
  margin-top: 3%;
  display: flex;
  flex-direction: column;
  & #date-filters {
    display: flex;
    margin: 20px auto;
    width: 45%;
    justify-content: space-between;
    & .date-filter {
      width: 45%;
      display: flex;
      justify-content: space-between;
      flex-direction: column;
      & label {
        font-size: 20px;
      }
      & .inputs {
        display: flex;
        justify-content: space-between;
        & input {
          padding: 8px;
          font-size: 15px;
          border-radius: 10px;
          border: 1px solid rgba(80, 80, 80, 0.4);
        }
      }
    }
  }
  & .get-button {
    display: flex;
    width: 20%;
    margin: 0 auto;
    justify-content: space-around;
  }
  & #data-list {
    margin-top: 20px;
    display: flex;
    & table {
      width: 50%;
      margin: 0 auto;
      list-style: none;
      border-radius: 4px;
      & th {
        border: none !important;
      }
      & .element-tr:hover {
        background-color: #d9def03d;
        cursor: pointer;
      }
    }
  }
  & .no-data {
    margin-top: 20px;
    font-weight: bold;
    font-size: 20px;
  }
}
</style>
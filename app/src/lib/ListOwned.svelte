<script lang='ts'>
import { Card } from 'flowbite-svelte';
import { createEventDispatcher } from 'svelte';
import type { OwnedAspect } from './types';

export let aspectName = "";
export let ownedList = [];

let ownedAspects: OwnedAspect[] = [];

const dispatch = createEventDispatcher();
async function deleteOwnedAspect(index: number) {
    const ownedAspectData = await localStorage.getItem(aspectName);
    if (ownedAspectData) {
        ownedAspects = JSON.parse(ownedAspectData);

        let ownedAspectList = ownedAspects;
        ownedAspectList.splice(index, 1);

        if (ownedAspectList.length === 0) {
          localStorage.removeItem(aspectName);
        } else {
          localStorage.setItem(aspectName, JSON.stringify(ownedAspects));
        }

        dispatch('aspectUpdated');
    }
    }

</script>

<Card class="p-2 md:p-4">
    <h3 class="text-sm md:text-base">Owned Aspects</h3>
    <ul class="text-sm md:text-base">
      {#each ownedList as ownedAspect, index}
        <li class="flex items-center">
          <Card class="p-1 md:p-2 flex items-center">
            <p class="text-xs md:text-base font-medium mr-2">{ownedAspect.note}</p>
            <svg
              fill="none"
              stroke="currentColor"
              stroke-width="1.5"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
              aria-hidden="true"
              class="w-6 h-6 md:w-8 md:h-8 ml-2 cursor-pointer"
              on:click={() => deleteOwnedAspect(index)}
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"
              ></path>
            </svg>
          </Card>
        </li>
      {/each}
    </ul>
  </Card>
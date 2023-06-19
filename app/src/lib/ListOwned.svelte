<script lang='ts'>
import { Card } from 'flowbite-svelte';
import { createEventDispatcher } from 'svelte';
import type { OwnedAspects } from './types';

export let aspectName = "";
export let ownedList = [];

let ownedAspects: OwnedAspects = {};

const dispatch = createEventDispatcher();
async function deleteOwnedAspect(index: number) {
    const ownedAspectsData = await localStorage.getItem('ownedAspects');
    if (ownedAspectsData) {
        ownedAspects = JSON.parse(ownedAspectsData);

        let ownedAspectList = ownedAspects[aspectName];
        ownedAspectList.splice(index, 1);

        if (ownedAspectList.length === 0) {
            delete ownedAspects[aspectName];
        } else {
            ownedAspects[aspectName] = ownedAspectList;
        }

        localStorage.setItem('ownedAspects', JSON.stringify(ownedAspects));
        dispatch('aspectUpdated');
    }
    }

</script>

<Card class="p-4">
    <h3>Owned Aspects</h3>
    <ul>
      {#each ownedList as ownedAspect, index}
        <li class="flex items-center">
            <Card class="p-2 flex items-center">
                <p class="text-base font-medium mr-2">{ownedAspect.note}</p>
                <svg
                  fill="none"
                  stroke="currentColor"
                  stroke-width="1.5"
                  viewBox="0 0 24 24"
                  xmlns="http://www.w3.org/2000/svg"
                  aria-hidden="true"
                  class="w-8 h-8 ml-2 cursor-pointer"
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
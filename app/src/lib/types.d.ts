export interface OwnedAspect {
  note: string
  time: string
}

export interface OwnedAspects {
  [name: string]: OwnedAspect[]
}

export interface AspectData {
  [name: string]: {
    category: string
    in_codex: boolean
    class: string
    name_localized: { [lang: string]: string }
    desc_localized: { [lang: string]: string }
  }
}

export type ItemType = 'AMULET' | '2H-WEAPON' | 'OTHER'

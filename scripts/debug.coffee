horoscope = [
  {
    'rank': 4
  },
  {
    'rank': 1
  }
]

# horoscope = objectSort horoscope

horoscope.sort((a, b) ->
  console.log (a.rank < b.rank)
  return (a.rank > b.rank) ? -1 : 1
)

console.log horoscope


ranking = (a, b) ->
  console.log 's'
  return (a.rank > b.rank) ? -1 : 1

objectSort = (object) ->
  sorted = {}
  array = []

  for key in object
    if object.hasOwnProperty key
      array.push key

  array.sort()

  for i in [0..array.length]
    sorted[array[i]] = object[array[i]]

  return sorted

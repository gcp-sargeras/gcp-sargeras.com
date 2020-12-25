import Link from 'next/link'

export default function Report({ report }){
  return <div>
    <Link href='/simc/reports'><a>back to index</a></Link>
    <h1>Report for {report.character}</h1>
  </div>
}

export async function getStaticProps({ params }) {
  const resp = await (await fetch(`${process.env.API_URL}/simc/reports/${params.id}.json`)).json()
  return {
    props: { report: resp }
  }
}

export async function getStaticPaths() {
  const resp = await (await fetch(process.env.API_URL + '/simc/reports')).json()
  return { paths: [], fallback: 'blocking' }
}

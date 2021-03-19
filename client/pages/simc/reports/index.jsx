import Link from 'next/link'

export default function Reports({ reports = [] }){
  return <div>
    {reports.map(r => <div key={r.id}>
      <Link href={`/simc/reports/${r.id}`}>
        <a>Report: {r.id} | Character: {r.character}</a>
      </Link>
    </div>)}
  </div>
}

export async function getStaticProps() {
  const resp = await (await fetch(process.env.API_URL + '/simc/reports')).json()
  return {
    props: { reports: resp },
    revalidate: 1
  }
}

class RestrictionTrackingReport < AbstractReport
  register_report(
    params: [['from', Date, 'The start of report range'],
             ['to', Date, 'The start of report range']]
  )

  def initialize(params, job, db)
    super

    from = params['from'] || Time.now.to_s
    to = params['to'] || Time.now.to_s

    @from = DateTime.parse(from).to_time.strftime('%Y-%m-%d %H:%M:%S')
    @to = DateTime.parse(to).to_time.strftime('%Y-%m-%d %H:%M:%S')

    info[:scoped_by_date_range] = "#{@from} & #{@to}"
  end

  def query
    binding.pry
    results = db.fetch(query_string)
    info[:total_count] = results.count
    results
  end

  def query_string
    <<~SOME_SQL
    SELECT if(resource.create_time like '%2015%', 'ADDITION', 'REVIEW') as collection_type
      , replace(replace(replace(replace(replace(resource.identifier, '[', ''), '"', ''), ',null', ''), ',', '-'), ']', '') as resource_id
      , resource.title as resource_title
      , accession.title as accession_title
      , upper(replace(replace(replace(replace(replace(accession.identifier, '[', ''), '"', ''), ',null', ''), ',', '-'), ']', '')) as accession_id
      , CONCAT(extent.number, ' ', ev.value) as extent
      , extent.container_summary
      , accession.accession_date
      , resource.create_time as resource_create_time
      , resource.finding_aid_date
    FROM accession
    LEFT JOIN extent on extent.accession_id = accession.id
    LEFT JOIN date on date.accession_id = accession.id
    LEFT JOIN enumeration_value ev on ev.id = extent.extent_type_id
    LEFT JOIN spawned_rlshp sr on sr.accession_id = accession.id
    LEFT JOIN resource on sr.resource_id = resource.id
    WHERE accession.repo_id = #{db.literal(@repo_id)}
    AND accession.accession_date BETWEEN #{db.literal(@from.split(' ')[0].gsub('-', ''))} AND #{db.literal(@to.split(' ')[0].gsub('-', ''))}
    SOME_SQL
  end

  def page_break
    false
  end
end

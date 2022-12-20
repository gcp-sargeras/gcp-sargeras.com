# frozen_string_literal: true

# Run a simulation with Simulationcraft
class SimcService < ApplicationService
  attr_reader :report

  def initialize(report)
    super()

    @report = report
    @bot = Discordrb::Bot.new(token: ENV['DISCORD_TOKEN'])
  end

  def call
    _stdout, stderr, status = call_simc

    return completion if status.to_i.zero?

    error(stderr)
  ensure
    delete_files!
  end

  private

  def simc_source
    if report.custom_string.present?
      custom_string_source
    elsif report.requester_attachment_url.present?
      requester_attachement_source
    else
      armory_souce
    end
  end

  def requester_attachement_source
    File.write(custom_file_location, HTTPClient.new.get(report.requester_attachment_url).body)

    custom_file_location
  end

  def custom_string_source
    File.write(custom_file_location, report.custom_string)

    custom_file_location
  end

  def armory_souce
    "armory=#{report.character.region.name},#{report.character.server.name},#{report.character.name}"
  end

  def call_simc
    Open3.capture3(
      "simc #{simc_source} "\
      "html=#{html_file_location} json2=#{json_file_location} " \
      "threads=#{ENV.fetch('SIMC_THREADS', 4)}}"
    )
  end

  def completion
    update_report!
  end

  def update_report!
    report.update(html_report: File.read(html_file_location),
                  json_report: JSON.parse(File.read(json_file_location)))
  end

  def delete_files!
    File.delete(html_file_location) if File.exist?(html_file_location)
    File.delete(json_file_location) if File.exist?(json_file_location)
    File.delete(custom_file_location) if File.exist?(custom_file_location)
  end

  def error(message)
    raise SimulationError, message
  end

  def html_file_location
    "#{Rails.root.join('reports')}/#{report.id}.html"
  end

  def json_file_location
    "#{Rails.root.join('reports')}/#{report.id}.json"
  end

  def custom_file_location
    Dir.mkdir(Rails.root.join('tmp', 'simc').to_s) unless Dir.exist?(Rails.root.join('tmp', 'simc').to_s)
    "#{Rails.root.join('tmp', 'simc')}/#{report.id}.simc"
  end

  class SimulationError < StandardError; end
end

# frozen_string_literal: true

class MainController < ApplicationController
  def index
    result = api_query
    @data = result.data
  end

  def status_counts
    result = api_query since1: 1.day.ago.utc.iso8601,
                       since2: 1.week.ago.utc.iso8601
    @stats_today = result.data.emails1.statistics
    @stats_this_week = result.data.emails2.statistics

    render partial: "status_counts", locals: { loading: false }
  end

  def reputation
    if request.xhr?
      render partial: "reputation", locals: {
        listings: DNSBL::Client.new.lookup(Reputation.local_ip),
        ip: Reputation.local_ip
      }
    else
      result = api_query
      @data = result.data
    end
  end
end
